javascript: 
var link = window.location.href; 
var description = document.querySelector("#description-val").innerText; 
var prDesc = `**Jira:** ${link}\n\n**Description:**\n${description}\n\n**Preview:**\n`; 
navigator.clipboard.writeText(prDesc); alert("Copied the text: " + prDesc);
