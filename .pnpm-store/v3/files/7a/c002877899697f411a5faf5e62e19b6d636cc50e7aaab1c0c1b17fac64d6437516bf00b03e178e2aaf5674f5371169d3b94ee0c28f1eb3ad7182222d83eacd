/**
 * @name Get contrasting text color
 * @description Get contrasting text color from a text color
 * @param bgColor  Background color of text.
 * @returns contrasting text color
 */
export declare const getContrastingTextColor: (bgColor: string) => string;
/**
 * @name Get formatted date
 * @description Get date in today, yesterday or any other date format
 * @param date  date
 * @param todayText  Today text
 * @param yesterdayText  Yesterday text
 * @returns formatted date
 */
export declare const formatDate: ({ date, todayText, yesterdayText, }: {
    date: string;
    todayText: string;
    yesterdayText: string;
}) => string;
/**
 * @name formatTime
 * @description Format time to Hour, Minute and Second
 * @param timeInSeconds  number
 * @returns formatted time
 */
export declare const formatTime: (timeInSeconds: number) => string;
/**
 * @name trimContent
 * @description Trim a string to max length
 * @param content String to trim
 * @param maxLength Length of the string to trim, default 1024
 * @param ellipsis Boolean to add dots at the end of the string, default false
 * @returns trimmed string
 */
export declare const trimContent: (content?: string, maxLength?: number, ellipsis?: boolean) => string;
/**
 * @name convertSecondsToTimeUnit
 * @description Convert seconds to time unit
 * @param seconds  number
 * @param unitNames  object
 * @returns time and unit
 * @example
 * convertToUnit(60, { minute: 'm', hour: 'h', day: 'd' }); // { time: 1, unit: 'm' }
 * convertToUnit(60, { minute: 'Minutes', hour: 'Hours', day: 'Days' }); // { time: 1, unit: 'Minutes' }
 */
export declare const convertSecondsToTimeUnit: (seconds: number, unitNames: {
    minute: string;
    hour: string;
    day: string;
}) => {
    time: string;
    unit: string;
} | {
    time: number;
    unit: string;
};
