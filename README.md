# kie-scripts
This is a collection of scripts to use with the KIE Tools repository. 
Create a symlink to them in your "~/bin" folder to use them.

* **build-kie-package**

    Builds a Kie package everywhere in kie-tools, guessing the package name from the current working directory.

    Examples:

	+ `build-kie-package -d @kie-tools/serverless-workflow-language-service`  
	Build a Kie package and his dependencies.

	+ `build-kie-package -d -s`                                                 
	From a package directory, builds and start the current package

	+ `build-kie-package vscode-extension-serverless-workflow-editor -d`    
	From any package directory, builds the specified package

    + `build-kie-package serverless-workflow-language-service -d`              
	From any package directory, builds the specified package.