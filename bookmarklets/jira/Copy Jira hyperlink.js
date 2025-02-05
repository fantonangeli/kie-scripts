javascript: 
var jiraTitle = document.title.replace(" - Red Hat Issue Tracker", "").replace(/\[(.+)\]/, "$1:"); 
var url = window.location.href; 
var result = `=HYPERLINK("${url}", "${jiraTitle}")`; 
navigator.clipboard.writeText(result); 
alert("Copied the text: " + result);
