const { send, sendToAll, close } = (() => {
  const ws = new WebSocket('ws://localhost:8888/websocket');
  ws.onmessage = (e) => console.log(e.data);
  const send = (message) => ws.send(message);
  const sendToAll = (message) => ws.send(`to:all:${message}`);
  return {
    send,
    sendToAll,
    close: ws.close,
  };
})();
