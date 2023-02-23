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
