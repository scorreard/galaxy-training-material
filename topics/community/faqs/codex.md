---
title: How do I add my community to the Galaxy CoDex?
box_type: tip
layout: faq
contributors: [bebatut, nomadscientist, scorreard]
---

This will guide you to create a codex for your community.
The microgalaxy codex is a good template to follow in order to see what should be included in each file.

> <hands-on-title>Create a folder for your community</hands-on-title>
>
> 1. If not already done, fork the [Galaxy Codex repository](https://github.com/galaxyproject/galaxy_codex)
> 2. Go to the `communities` folder
> 3. Click on **Add file** in the drop-down menu at the top
> 4. Select **Create a new file**
> 5. Fill in the `Name of your file` field with:  name of your community + `/metadata/`
>
>    This will create a folder for your community and a new folder for your community called metadata.
>
> <hands-on-title>Add tools to your community codex</hands-on-title>
> 
> 1. Create the categories file in your community meatadata folder
> 2. In the categories file, indicate catgories from the [Galaxy Tool Shed](https://toolshed.g2.bx.psu.edu/) that are relevant to your community
>    Indicate one category per line.
> 3. Once this is done, it will automatically create a tool_status.tsv file which will include a list of tools pulled from the Galaxy Tool Shed, based on the list of categories you listed.
>    It may take up to a week to create this file.
>    This file is composed of five columns : "Suite ID", "Suite owner", "Description", "To keep", "Deprecated"
> 4. Review manually the tool_status.tsv file to select the tools to include in the community codex.
>    To do that, only columns four ("To keep") and five ("deprecated") should be updated.
>    If the tool is releavant and used by your community, the "To keep" column should indicate TRUE
>    If the tool is no longer releavant or used by your community, the "Deprecated" column should indicate TRUE
> 5. Once this is done, it will automatically create a curated_tools.tsv file which will include the tools that were judge relevant for the community.
>    It may take up to a week to create this file.
>
> <hands-on-title>Add tutorials to your community codex</hands-on-title>
>
> 1. Create the tutorial_tags file in your community meatadata folder
> 2. In the tutorial_tags file, indicate the tags that are used to tag the tutorials relevant to your community.
>    Indicate one tag per line.
>
> One option is to create a tag (for example, your community name) and use this tag for all the tutorials you want included in the codex. Then, you only need to indicate this tag in the tutorial_tags file to pull all the relevant tutorials.
>
> 3. Once this is done, it will automatically create a tutorials.tsv file which will include a list of tutorials, based on the tags you listed.
>    It may take up to a week to create this file.
>
> <hands-on-title>Add workflows to your community codex</hands-on-title>
>
> 1. Create the workflow_tags file in your community meatadata folder
> 2. In the workflow_tags file, indicate the tags that are used to tag the workflows relevant to your community.
>    The file is split in two sections : Public, which should inidcate the tags to use to select workflow on public Galaxy instances; workflowhub, which should inidcate the tags to use to select workflow on workflowhub. See example below
```
public:
- name:microgalaxy
- microgalaxy
workflowhub:
- abromics
- amr
- amplicon
```
>
> 3. Once this is done, it will automatically create a workflow_status.tsv file which will include a list of workflows, based on the tags you listed.
>    It may take up to a week to create this file.
{: .hands_on}
