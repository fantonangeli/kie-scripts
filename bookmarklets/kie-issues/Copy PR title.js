javascript: var text = document.title.replace(/^^([^·]+) · Issue #(\d+) .*$/g, "kie-issues#$2: $1"); navigator.clipboard.writeText(text); alert("Copied the text: " + text);
