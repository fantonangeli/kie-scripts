javascript: 
var jiraTitle = document.title.replace(" - Red Hat Issue Tracker", "").replace(/\[(.+)\]/, "$1:"); 
navigator.clipboard.writeText(jiraTitle); 
alert("Copied the text: " + jiraTitle);
