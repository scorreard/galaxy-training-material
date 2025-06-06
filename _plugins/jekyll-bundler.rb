require 'digest'

# While reading in all of the files for the site
# load the bundles and find out their last modified time
# so we can use that as a cache buster
Jekyll::Hooks.register :site, :post_read do |site|
  site.config['javascript_bundles'].each do |name, resources|
    if Jekyll.env == 'production'
      # Get the maximum last file modified time to use as the bundle timestamp
      bundle_timestamp = resources['resources'].map { |f| File.mtime(f).to_i }.max
      site.config['javascript_bundles'][name]['timestamp'] = bundle_timestamp

      # This is inefficient since we read twice but it's also not that expensive.
      bundle = resources['resources'].map { |f| File.read(f) }.join("\n")
      hash = Digest::MD5.hexdigest(bundle)[0..7]
      site.config['javascript_bundles'][name]['hash'] = hash
      site.config['javascript_bundles'][name]['path'] = "/assets/js/bundle.#{name}.#{hash}.js"

      Jekyll.logger.info "[GTN/Bundler] Analysing JS Bundle #{name} => #{bundle_timestamp} / #{hash}"
    else
      Jekyll.logger.info '[GTN/Bundler] Serving plain JS'
    end
  end
end

# When writing the site, build the bundles
# It's basically "cat *.js > bundle.js"
# We don't need no fancy JS minification
# gzip probably does enough, everything else is pre-minified.
Jekyll::Hooks.register :site, :post_write do |site|
  site.config['javascript_bundles'].each do |name, resources|
    if Jekyll.env == 'production'
      bundle_path = "#{site.dest}#{resources['path']}"
      Jekyll.logger.info "[GTN/Bundler] Building JS bundle #{name} => #{bundle_path}"

      # Just concatenate them all together
      bundle = resources['resources'].map { |f| File.read(f) }.join("\n")

      # Write the bundle to the output directory
      File.write(bundle_path, bundle)
    end
  end
end

module Jekyll
  module Filters

    # Our (very simple) JS Bundler
    module JsBundle
      ##
      # Setup the local cache via +Jekyll::Cache+
      def cache
        @@cache ||= Jekyll::Cache.new('GtnJsBundle')
      end

      # Return the preloads for the bundles, when in production
      # +test+:: ignore this
      # Returns the HTML to load the bundle
      #
      # Example:
      # {{ 'load' | bundle_preloads }}
      def bundle_preloads(_test)
        if Jekyll.env == 'production'
          bundle_preloads_prod
        else
          ''
        end
      end

      # (Internal) Return the production preloads for the bundles
      def bundle_preloads_prod
        bundles = @context.registers[:site].config['javascript_bundles']
        baseurl = @context.registers[:site].config['baseurl']

        # Select the ones wishing to be preloaded
        bundles = bundles.select do |_name, bundle|
          bundle['preload'] == true
        end

        bundles.map do |_name, bundle|
          bundle_path = "#{baseurl}#{bundle['path']}"
          "<link rel='preload' href='#{bundle_path}' as='script'>"
        end.join("\n")
      end

      # Load a specific bundle, in liquid
      # +name+:: the name of the bundle to load
      # Returns the HTML to load the bundle
      #
      # Example:
      # {{ 'main' | load_bundle }}
      def load_bundle(name)
        cache.getset("#{Jekyll.env}-#{name}") do
          if Jekyll.env == 'production'
            load_bundle_production(name)
          else
            load_bundle_dev(name)
          end
        end
      end

      ##
      # Dev version of the bundle loader, just direct script links
      def load_bundle_dev(name)
        bundle = @context.registers[:site].config['javascript_bundles'][name]
        raise "Bundle #{name} not found in site config" if bundle.nil?

        Jekyll.logger.debug "[GTN/Bundler] Bundle #{bundle}"

        baseurl = @context.registers[:site].config['baseurl']

        bundle['resources'].map do |f|
          "<script src='#{baseurl}/#{f}'></script>"
        end.join("\n")
      end

      ##
      # Production version of the bundle loader, with cache busting
      def load_bundle_production(name)
        bundle = @context.registers[:site].config['javascript_bundles'][name]
        raise "Bundle #{name} not found in site config" if bundle.nil?

        baseurl = @context.registers[:site].config['baseurl']
        attrs = ''
        attrs += ' async' if bundle['async']
        attrs += ' defer' if bundle['defer']
        bundle_path = "#{baseurl}#{bundle['path']}"
        "<script #{attrs} src='#{bundle_path}'></script>"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Filters::JsBundle)
