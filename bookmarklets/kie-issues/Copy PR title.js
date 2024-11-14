javascript: 
var issuePrefix="kie-issues#";
window.location.href.startsWith("https://github.com/apache/incubator-kie-tools") && (issuePrefix="kie-tools-issues#");
var text = document.title.replace(/^^([^·]+) · Issue #(\d+) .*$/g, `${issuePrefix}$2: $1`); 
navigator.clipboard.writeText(text); 
alert("Copied the text: " + text);
