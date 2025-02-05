javascript: 
var branchName = document.title.replace(" - Red Hat Issue Tracker", "").replace(/\s{1,}/mg, "-").replace(/--*/mg, "-").replace(/\[(.+)\]/, "$1").replace(/[^a-zA-Z0-9-]+/g, ""); 
navigator.clipboard.writeText(branchName); 
alert("Copied the text: " + branchName);
