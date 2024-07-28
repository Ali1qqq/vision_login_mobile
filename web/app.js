window.state = {
    data: ''
}

function initNFC() {
 try {
  const ndef = new NDEFReader();
  ndef.scan();
  ndef.addEventListener("readingerror", () => {
      return "no"
  });
  ndef.addEventListener("reading", ({ message, serialNumber }) => {
  window.state = {
      data: serialNumber
  }
   window.parent.postMessage('any message', "*");
  });
   return "ok"
    } catch (error) {
      // alert("your Device is not support NFC")
       return "no"
    }

}

