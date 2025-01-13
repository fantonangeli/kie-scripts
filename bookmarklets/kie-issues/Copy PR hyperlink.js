javascript: 
var prTitle = document.title.replace(/^(.*) by w+ · Pull Request #d+ · [S]+$/g, "$1"); 
var url = window.location.href; 
var result = `=HYPERLINK("${url}", "${prTitle}")`; 
navigator.clipboard.writeText(result); 
alert("Copied the text: " + result);
