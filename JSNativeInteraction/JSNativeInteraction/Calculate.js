Calculate = {
square:function(num,callback) {
    Queue.push(Task.init(Queue.length, callback));
    window.webkit.messageHandlers.Beyond.postMessage({className: 'CalculatePlugin', functionName: 'square',taskId : Queue.length - 1, data: {"number":num}});
}
}


