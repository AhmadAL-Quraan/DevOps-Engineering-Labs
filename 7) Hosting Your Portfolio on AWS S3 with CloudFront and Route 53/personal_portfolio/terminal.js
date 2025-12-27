const terminal = document.getElementById("terminal");

const lines = [
  { type: "command", text: "> echo $SHELL" },
  { type: "output", text: "/usr/bin/zsh" },

  { type: "command", text: "> whoami" },
  { type: "output", text: "- Hello, I'm Ahmad Al-Quraan" },
  {type: "output", text: "- My nickname is ZAX_80"},
  {type: "output", text:"- A final year student, studying Computer Science at شاورمجي"},

  { type: "command", text: "> cat skills.txt" },
  { type: "output", text: "- Problem solving using Algorithms & DS" },
  { type: "output", text: "- Debugging سيد من عمل" },

{type: "command", text: "> cat programming_languages.txt"},
  { type: "output", text: "- C/C++ → Intermediate" },
  { type: "output", text: "- Java → Mid-level to Intermediate" },
  { type: "output", text: "- Bash-scripting → Mid-level" },
  { type: "output", text: "- HTML/CSS → Mid-level" },
  { type: "output", text: "- Python → Beginner" },
  {type: "output", text:"- Rust → Beginner"},

 { type: "command", text: "> cat my_interests.txt" },
{ type: "output", text: "- Systems administration and low-level problem solving." },
{ type: "output", text: "- Software Engineering." },
{ type: "output", text: "- Linux Systems." },
{ type: "output", text: "- Building my own OS using xv6 (learning why it's a bad idea)." }, 
{ type: "output", text: "- I don't like AWS." }, 

 
{ type: "command", text: "> cat frameworks.txt" },
{ type: "output", text: "Spring boot" },
  
];

let lineIndex = 0;

function typeLine(line, callback) {
  const el = document.createElement("div");
  el.className = line.type;
  terminal.appendChild(el);

  let i = 0;
  const cursor = document.createElement("span");
  cursor.className = "cursor";
  el.appendChild(cursor);

  const interval = setInterval(() => {
    if (i < line.text.length) {
      el.insertBefore(
        document.createTextNode(line.text[i]),
        cursor
      );
      i++;
    } else {
      clearInterval(interval);
      cursor.remove();
      callback();
    }
  }, 40); // typing speed
}

function runTerminal() {
  if (lineIndex >= lines.length) return;

  typeLine(lines[lineIndex], () => {
    lineIndex++;
    setTimeout(runTerminal, 400);
  });
}

runTerminal();

