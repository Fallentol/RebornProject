import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export * from './cbUtils';

export const _fireMessage = (function () {

    return {
        success: (_this, message, title, mode) => {
            _this.dispatchEvent(new ShowToastEvent({
                title,
                message,
                variant: 'success',
                mode,
            }))
        },
        error: (_this, message, title, mode) => {
            _this.dispatchEvent(new ShowToastEvent({
                title,
                message,
                variant: 'error',
                mode,
            }))
        },
        warning: (_this, message, title, mode) => {
            _this.dispatchEvent(new ShowToastEvent({
                title,
                message,
                variant: 'warning',
                mode,
            }))
        },
        other: (_this, message, title, mode) => {
            _this.dispatchEvent(new ShowToastEvent({
                title,
                message,
                variant: 'other',
                mode,
            }))
        }
    };


}())

export const _isInvalid = (function (t) {
    return (t === undefined || !t || t === 'undefined');
}
);

export const _cl = (function (message, color) {
    try {
        console.log(`%c🌩️ ${message}`, `color:${color}; font: 1 Tahoma; font-size: 1.2em; font-weight: bolder; padding: 2px;`);
    } catch (e) {

    }
});

