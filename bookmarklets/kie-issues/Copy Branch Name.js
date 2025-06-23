javascript:
var issuePrefix="kie-issues#";
window.location.href.startsWith("https://github.com/apache/incubator-kie-tools") && (issuePrefix="kie-tools#");
var branchName = document.title.replace(/^^([^·]+) · Issue #(\d+) .*$/g, `${issuePrefix}$2: $1`).replace(/\s{1,}/mg, "-").replace(/--*/mg, "-").replace(/\[(.+)\]/, "$1").replace(/[^a-zA-Z0-9-#]+/g, ""); 
navigator.clipboard.writeText(branchName); 
alert("Copied the text: " + branchName);
