javascript: 
var link = window.location.href; 
var description = document.querySelector(".comment-body").innerText; 
var prDesc = `**Closes** ${link}\n\n**Description:**\n${description}\n\n**Preview:**\n`; 
navigator.clipboard.writeText(prDesc); 
alert("Copied the text:\n " + prDesc)
