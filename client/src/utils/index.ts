/**
 * Converts an hex value to ASCII text
 * @param hexValue Hexadecimal value
 * @returns ASCII text equivalent of `hexValue`
 */
export const convertHexToText = (hexValue: string) => {
  const stripHex = hexValue[0].slice(2);

  if (!stripHex) {
    return "--Error--";
  }

  const stringValue = stripHex
    .toString()
    .match(/.{1,2}/g)
    ?.reduce((acc, char) => acc + String.fromCharCode(parseInt(char, 16)), "");
  return stringValue;
};
