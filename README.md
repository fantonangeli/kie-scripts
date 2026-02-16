## KIE-scripts

This is a collection of scripts to use with the KIE Tools repository.  
Create a symlink for them in your "~/bin" folder to use them.

### **build-kie-package**

  
Usage :  /home/fantonan/bin/build-kie-package \[package\] \[options\]  
Build a Kie package everywhere in kie-tools.

Options:

\-b|--bootstrap          Run pnpm bootstrap on the repository root before building  
\-d|--build-deps         Build the dependencies  
\-h|--help               Display this message  
\-p|--production         Buil in production mode  
\-q|--quiet              Do not show notifications  
\-s|--start              Start the package, if it's only one  
\-t|--test               Test the packages  
\-v|--version            Display script version  
\-w|--watch              Watches for file changes and run pnpm build:dev for a package. Does not support other options. Requires nodemon

Examples:  
build-kie-package -d @kie-tools/serverless-workflow-language-service    Build a Kie package and his dependencies.  
build-kie-package -d -s                                                 From a package directory, builds and start the current package  
build-kie-package vscode-extension-serverless-workflow-editor -d        From any package directory, builds the specified package  
build-kie-package serverless-workflow-language-service -d               From any package directory, builds the specified package.


### **drakt-build**

Usage: drakt-build.sh [upstream|midstream] \<branch\>
Builds and caches KIE artifacts (Drools, Kogito Runtimes, Kogito Apps) into the local Maven repository and stores them for future use.

The script clones the specified branch from either upstream (Apache) or midstream (kiegroup) repositories, runs a quick Maven install skipping tests, and removes the cloned directories. After building, it saves the artifacts to ~/.m2/kie-artifacts/$MODE/$BRANCH for later switching with drakt-switch. It also updates ~/.m2/drakt-env.sh to track the current configuration.

Examples:
drakt-build.sh midstream main               Build and cache main branch artifacts from midstream repositories
drakt-build.sh upstream 9.103.x-prod        Build and cache 9.103.x-prod branch artifacts from upstream repositories


### **drakt-switch**

Usage: drakt-switch [upstream|midstream] \<branch\>
Switches between pre-built KIE artifacts stored in ~/.m2/kie-artifacts.

The script replaces the current Maven local repository artifacts (org/kie and org/apache/kie) with cached versions from the specified mode and branch. It also updates ~/.m2/drakt-env.sh to track the current configuration.

Examples:
drakt-switch midstream main              Switch to cached midstream artifacts for main branch
drakt-switch upstream 9.103.x-prod       Switch to cached upstream artifacts for 9.103.x-prod branch


### **bookmarklets**

A collection of useful bookmarklets for Firefox and Chrome.

- **Copy Branch Name.js**: If run from a Jira issue, generate a branch name for the current issue using the kebab case.
- **Copy Jira Title.js**: If run from a Jira issue, copies the issue's title.
- **Copy PR Description.js**: If run from a Jira issue, copies the markdown formatted issue description ready to be pasted in a pull request.

