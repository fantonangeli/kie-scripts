javascript: 
var jiraTitle = document.title.replace(" - Red Hat Issue Tracker", "").replace(/\[([\w-]+)\]/, "$1:");
navigator.clipboard.writeText(jiraTitle); 
alert("Copied the text: " + jiraTitle);
