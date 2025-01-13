#!/bin/bash
BOOTSTRAP=false
PKGBOOTSTRAP=false
BUILDDEPS=false
FASTBUILD=false
ENV="dev"
QUIET=false
STARTPKG=false
TESTPKG=false
VERSION="0.10"
WATCH=false
kiePkgPrefix="@kie-tools"
packagesToExcludeInFastBuild=" -F !serverless-workflow-diagram-editor -F !dmn-marshaller -F !dashbuilder -F !dashbuilder-editor -F !yard-model -F !dmn-marshaller -F !dmn-testing-models -F !yard-validator-worker -F !stunner-editors"
kieToolsPath=""
origPwd=`pwd`
packagesDir="packages"
examplesDir="examples"
pkgName=""
kieToolsPath=$(pwd | sed -E "s@(.*\/kie-tools).*@\1@")

function print_log_section(){
    echo "------------------------------------------------------------------------------------------------------------------------------------------------------"
}

function get_pkg_path() {
    currentPkgName=$1
    if [[ -d $currentPkgName ]]; then
        echo $currentPkgName
    elif [[ -d  "$kieToolsPath/$packagesDir/$currentPkgName" ]]; then
        echo "$kieToolsPath/$packagesDir/$currentPkgName"
    else 
        echo "$kieToolsPath/$examplesDir/$currentPkgName"
    fi
}

function get_pkg_build_name() {
    currentPkgName=$1
    packagePath=$(get_pkg_path $currentPkgName)

    if [[ -d $packagePath ]]; then
        (cd $packagePath; echo `npm pkg get name  | sed 's/"//g'`)
    else
        exit 0
    fi
}
    
function build_package() {
    pkgName=$1
    pkgBuildName=$(get_pkg_build_name $pkgName)
    print_log_section
    echo "Building package: $pkgBuildName"

    if [[ $FASTBUILD = true ]]; then
        fastFilters=$packagesToExcludeInFastBuild
    fi

    if [[ ! $BUILDDEPS = true ]]; then
        (cd "$kieToolsPath/$packagesDir/$pkgName"; pnpm run build:$ENV)
        exitStatus=$?
    else
        echo "Executing: pnpm -F $pkgBuildName...$fastFilters build:$ENV"
        (cd $kieToolsPath; time pnpm -F $pkgBuildName...$fastFilters build:$ENV)
        exitStatus=$?
    fi

    if [ $exitStatus -ne 0 ]; then
        echo "Error: Failed to build $pkgBuildName"
        notify "Build failed"
        exit 1
    fi
}
    
function run_package_command() {
    currentPkgName=$1
    packagePath=$(get_pkg_path $currentPkgName)
    commandToRun=$2

    if [[ -d $packagePath ]]; then
        (
            cd $packagePath
            eval $commandToRun
        )
        if [ $? -ne 0 ]; then
            echo "Error: Filed to run '$commandToRun'"
            exit 1
        fi
        printf '\n'
    fi
}

function package_bootstrap() {
    pkgBuildName=$(get_pkg_build_name $pkgName)

    (
        cd $kieToolsPath
        pnpm bootstrap -F $pkgBuildName...
    )

    if [ $? -ne 0 ]; then
        echo "Error: Failed to bootstrap $pkgBuildName"
        exit 1
    fi
}

function repo_bootstrap() {
    (
        cd $kieToolsPath
        pnpm bootstrap
    )

    if [ $? -ne 0 ]; then
        echo "Error: Failed to bootstrap"
        exit 1
    fi
}

function notify() {
    message=$1

    if [[ ! $QUIET = true ]]; then
        notify-send $message
    fi
}

function get_package_name() {
    fullPkgName=$1
    echo $fullPkgName | sed -E "s/(@kie-tools\\/)?(.*)/\2/"
}

function usage()
{
    echo "Usage :  $0 [package] [options]
    Build a Kie package everywhere in kie-tools.

    Options:
    -B|--bootstrap          Run "pnpm bootstrap" on the repository root before building
    -b|--pkb-bootstrap      Run "pnpm bootstrap" for the package before building
    -d|--build-deps         Build the dependencies
    -f|--fast-build         Skip heavy dependencies like @kie-tools/serverless-workflow-diagram-editor
    -h|--help               Display this message
    -p|--production         Buil in production mode
    -q|--quiet              Do not show notifications
    -s|--start              Start the package, if it's only one
    -t|--test               Test the packages
    -v|--version            Display script version
    -w|--watch              Watches for file changes and run "pnpm build:dev" for a package. Does not support other options. Requires nodemon

    Examples:
    build-kie-package -d @kie-tools/serverless-workflow-language-service    Build a Kie package and his dependencies.
    build-kie-package -d -s                                                 From a package directory, builds and start the current package
    build-kie-package vscode-extension-serverless-workflow-editor -d        From any package directory, builds the specified package
    build-kie-package serverless-workflow-language-service -d               From any package directory, builds the specified package.
    "
}    

while [[ $# -gt 0 ]]; do
  case $1 in
    -B|--bootstrap)
      BOOTSTRAP=true
      shift
      ;;
    -b|--pkg-bootstrap)
      PKGBOOTSTRAP=true
      shift
      ;;
    -d|--build-deps)
      BUILDDEPS=true
      shift
      ;;
    -f|--fast-build)
      FASTBUILD=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      shift
      ;;
    -p|--production)
      ENV="prod"
      shift 
      ;;
    -q|--quiet)
      QUIET=true
      shift 
      ;;
    -s|--start)
      STARTPKG=true
      shift
      ;;
    -t|--test)
      TESTPKG=true
      shift
      ;;
    -v|--version)
      echo "Version: $VERSION"
      exit 0
      shift
      ;;
    -w|--watch)
      WATCH=true
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      pkgName=$1
      shift
      ;;
  esac
done


########################################################################

if [ $WATCH = true ]  &&  ([ $BUILDDEPS = true ] || [ $FASTBUILD = true ] || [ $STARTPKG = true ]); then
    echo "Watch option can only accept --test option"
    exit 1
fi

if [ ! -d $kieToolsPath ]; then
    echo "Repository root not found"
    exit 1
fi

if [ -z "$pkgName" ]; then
    pkgName=${PWD##*/}
else 
    pkgName=$(get_package_name $pkgName )
fi 

if [[ $BOOTSTRAP = true ]]; then
    repo_bootstrap
fi

if [[ $PKGBOOTSTRAP = true ]]; then
    package_bootstrap
fi

if [ $WATCH = false ]; then
    build_package $pkgName 
fi

cd $origPwd

notify "Build done"

if [ $TESTPKG = true ] && [ $WATCH = false ]; then
    run_package_command $pkgName "pnpm test"
fi

if [ $STARTPKG = true ]; then
    run_package_command $pkgName "pnpm start"
fi

if [ $WATCH = true ] && [ $BUILDDEPS = false ] && [ $FASTBUILD = false ] && [ $STARTPKG = false ]; then
    if [ $TESTPKG = false ]; then
        run_package_command $pkgName 'nodemon -w src -e "ts,tsx,js,css" -x "pnpm build:dev || true; notify-send \"Nodemon build: done\""'
    else
        run_package_command $pkgName 'nodemon -w src -e "ts,tsx,js,css" -x "(pnpm build:dev && notify-send \"Nodemon build: done\" && pnpm test) || true"'
    fi
fi

