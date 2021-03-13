let getTermOptions = () => {
  return [
    { label: "20 years", value: 20 },
    { label: "25 years", value: 25 }
  ];
};

let calculateValues = (val1, val2, val3) => {
  return val1 + val2 + val3;
};

export { getTermOptions, calculateValues };
