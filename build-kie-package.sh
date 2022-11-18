#!/bin/bash
VERSION="0.1"
ENV="dev"
origPwd=`pwd`
packagesDir="packages"
kiePkgPrefix="@kie-tools"
kieToolsPath=""
BUILDDEPS=false
QUIET=false
STARTPRJ=false
TESTPKG=false
pkgName=""
kieToolsPath=$(pwd | sed -E "s@(.*\/kie-tools).*@\1@")

function get_pkg_path() {
    currentPkgName=$1
    if [[ -d $currentPkgName ]]; then
        echo $currentPkgName
    else
        echo "$kieToolsPath/$packagesDir/$currentPkgName"
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
    currentPkgName=$1
    echo "Building package: $currentPkgName"

    if [[ ! $BUILDDEPS = true ]]; then
        (cd "$kieToolsPath/$packagesDir/$currentPkgName"; pnpm run build:$ENV)
        exitStatus=$?
    else
        (cd $kieToolsPath; time pnpm -r -F $currentPkgName... build:$ENV)
        exitStatus=$?
    fi

    if [ $exitStatus -ne 0 ]; then
        notify "Build failed"
        exit 1
    fi
}
    
function test_package() {
    currentPkgName=$1
    packagePath=$(get_pkg_path $currentPkgName)

    if [[ $TESTPKG = true && -d $packagePath ]]; then
        (
            cd $packagePath
            pnpm run test
        )
        if [ $? -eq 0 ]; then
            exit 1
        fi
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

function start_pkg_build() {
    pkgName=$1
    pkgBuildName=$(get_pkg_build_name $pkgName)

    echo "Changed location to `pwd`"

    build_package $pkgBuildName
    test_package $pkgName
}

function usage()
{
    echo "Usage :  $0 [package 1] [options]
    Build a Kie package everywhere in kie-tools.

    Options:
    -q|--quiet           Do not show notifications
    -p|--production     Buil in production mode
    -s|--start             Start the package, if it's only one
    -d|--build-deps     Build the dependencies
    -t|--test           Test the packages
    -h|--help             Display this message
    -v|--version          Display script version

    Examples:
    build-kie-package -d @kie-tools/serverless-workflow-language-service    Build a Kie package and his dependencies.
    build-kie-package -d -s                                                 From a package directory, builds and start the current package
    build-kie-package vscode-extension-serverless-workflow-editor -d        From any package directory, builds the specified package
    build-kie-package serverless-workflow-language-service -d               From any package directory, builds the specified package.
    "
}    

while [[ $# -gt 0 ]]; do
  case $1 in
    -q|--quiet)
      QUIET=true
      shift 
      ;;
    -p|--production)
      ENV="prod"
      shift 
      ;;
    -s|--start)
      STARTPRJ=true
      shift
      ;;
    -t|--test)
      TESTPKG=true
      shift
      ;;
    -d|--build-deps)
      BUILDDEPS=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      shift
      ;;
    -v|--version)
      echo "Version: $VERSION"
      exit 0
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

if [[ -z "$pkgName" ]]; then
    pkgName=${PWD##*/}
else 
    pkgName=$(get_package_name $pkgName )
fi 

start_pkg_build $pkgName 

cd $origPwd

notify "Build done"

if [[ $STARTPRJ = true ]]; then
    pnpm start
fi


