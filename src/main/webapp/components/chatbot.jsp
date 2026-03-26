<!-- ================= CHATBOT COMPONENT ================= -->

<style>
#chatbot-icon {
    position: fixed;
    bottom: 20px;
    right: 20px;
    cursor: pointer;
    z-index: 9999;
}

#chatbot-icon img {
    width: 100px;
    height: 100px;
}

#chat-container {
    position: fixed;
    bottom: 90px;
    right: 20px;
    width: 320px;
    height: 420px;
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0px 5px 20px rgba(0,0,0,0.3);
    display: none;
    flex-direction: column;
    z-index: 9999;
    font-family: Arial, sans-serif;
}

#chat-header {
    background: #007bff;
    color: white;
    padding: 12px;
    border-radius: 12px 12px 0 0;
    text-align: center;
    font-weight: bold;
}

#chat-messages {
    flex: 1;
    padding: 10px;
    overflow-y: auto;
    font-size: 14px;
}

.message-user {
    text-align: right;
    margin: 5px 0;
}

.message-bot {
    text-align: left;
    margin: 5px 0;
}

#chat-input-area {
    display: flex;
    border-top: 1px solid #ccc;
}

#chat-input-area input {
    flex: 1;
    padding: 10px;
    border: none;
    outline: none;
}

#chat-input-area button {
    padding: 10px;
    border: none;
    background: #007bff;
    color: white;
    cursor: pointer;
}
</style>

<!-- Robot Icon -->
<div id="chatbot-icon" onclick="toggleChat()">
<img src="${pageContext.request.contextPath}/components/robot.png" alt="Chatbot"></div>

<!-- Chat Window -->
<div id="chat-container">
    <div id="chat-header">
        Public Service Assistant
    </div>

    <div id="chat-messages"></div>

    <div id="chat-input-area">
        <input type="text" id="userMessage" placeholder="Ask something...">
        <button onclick="sendMessage()">Send</button>
    </div>
</div>

<script>
function toggleChat() {
    var chat = document.getElementById("chat-container");
    chat.style.display = (chat.style.display === "flex") ? "none" : "flex";
}

function sendMessage() {

    var message = document.getElementById("userMessage").value;

    if(message.trim() === "") return;

    var chatBox = document.getElementById("chat-messages");

    chatBox.innerHTML += "<div class='message-user'><b>You:</b> " + message + "</div>";

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "http://localhost/chatbot.php", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    xhr.onload = function() {
        chatBox.innerHTML += "<div class='message-bot'><b>Bot:</b> " + this.responseText + "</div>";
        chatBox.scrollTop = chatBox.scrollHeight;
    };

    xhr.send("message=" + encodeURIComponent(message));

    document.getElementById("userMessage").value = "";
}
</script>

<!-- ================= END CHATBOT ================= -->