javascript: 
var issueTitle = document.title.replace(/^^([^·]+) · Issue #(\d+).*$/, "$1");
var issueNumber = document.title.match(/Issue #(\d+)/)[1];
var issueUrl = window.location.href;
var result = `=HYPERLINK("${issueUrl}", "${issueTitle}")`;
navigator.clipboard.writeText(result);
alert("Copied the text: " + result);
