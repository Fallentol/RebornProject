(function () {

    function sayHello() {
        console.log('hello from helloModule.js');
    }
    // this makes the sayHello function available in the window     namespace
    // so we can call window.sayHello from any LWC JS file
    window.sayHello = sayHello;

    window._message = (cmp, message, title) => {
        alert('STATIC RESOURCE');
        return {

            fireSuccess: function (cmp, message, title) {
                cmp.dispatchEvent(
                    new ShowToastEvent({
                        title,
                        message,
                        variant: 'success',
                    }),
                );
            },
            fireWarning: function (cmp, message, title) {
                cmp.dispatchEvent(
                    new ShowToastEvent({
                        title,
                        message,
                        variant: 'warning',
                    }),
                );
            },

        }
    }

})();





