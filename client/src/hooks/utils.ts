export const capColors: string[] = ["R", "G", "Y", "B"];

export const posReducer = (data: number[], playersLength: number) => {
  const game: { [key: string]: string } = {};
  data.map((d, i) => {
    if (i < playersLength * 4) {
      if (d === 0) {
        game[markers[i]] = `${capColors[Math.floor(i / 4)]}0${(i % 4) + 1}`;
      } else if (d > 1000) {
        game[markers[i]] = `${capColors[Math.floor(i / 4)]}${d % 1000}`;
      } else {
        game[markers[i]] = `${d}`;
      }
    }
    return true;
  });
  return game;
};

const startPoints: number[] = [0, 13, 26, 39];

export const BoardToPos = (arr: number[]) => {
  const newArr: number[] = arr?.map((val, i) => {
    const color: number = Math.floor(i / 4);
    if (val > 52) {
      return 51 + (val % 1000);
    } else if (val === 0) {
      return 0;
    } else {
      return val - startPoints[color] < 1
        ? val - startPoints[color] + 52
        : val - startPoints[color];
    }
  });
  return newArr;
};

export const PosToBoard = (arr: number[]) => {
  const newArr: number[] = arr?.map((val, i) => {
    const color: number = Math.floor(i / 4);
    if (val > 51) {
      return (color + 1) * 1000 + (val % 50) - 1;
    } else if (val === 0) {
      return 0;
    } else {
      const a = (startPoints[color] + val) % 52;
      return a === 0 ? 52 : a;
    }
  });
  return newArr;
};

export const startState: { [key: string]: string } = {
  r0: "R01",
  r1: "R02",
  r2: "R03",
  r3: "R04",
  g0: "G01",
  g1: "G02",
  g2: "G03",
  g3: "G04",
  y0: "Y01",
  y1: "Y02",
  y2: "Y03",
  y3: "Y04",
  b0: "B01",
  b1: "B02",
  b2: "B03",
  b3: "B04",
};

export const markers: string[] = [
  "r0",
  "r1",
  "r2",
  "r3",
  "g0",
  "g1",
  "g2",
  "g3",
  "y0",
  "y1",
  "y2",
  "y3",
  "b0",
  "b1",
  "b2",
  "b3",
];

export const safePos: number[] = [
  1, 9, 14, 22, 27, 35, 40, 48, 1001, 1002, 1003, 1004, 1005, 2001, 2002, 2003,
  2004, 2005, 3001, 3002, 3003, 3004, 3005, 4001, 4002, 4003, 4004, 4005,
];

export const animateCustomEase = (
  duration: number,
  /* eslint-disable  @typescript-eslint/no-explicit-any */
  easing: any,
  element: HTMLSpanElement,
  /* eslint-disable  @typescript-eslint/no-explicit-any */
  property: any,
  currentValue: number,
  toValue: number
) => {
  const d = duration,
    ea = easing,
    e = element,
    // eslint-disable-next-line
    p = property,
    fromV = currentValue,
    toV = toValue;
  let lastStart: number | null = null;
  const animate = function (timestamp: number) {
    // check if this is a new animation
    if (!lastStart) {
      lastStart = timestamp;
    }
    // check still in animation range
    if (timestamp - lastStart <= d) {
      // do animation
      e.style[property] = ea(timestamp - lastStart, 0, d, fromV, toV);
      // call next frame
      window.requestAnimationFrame(animate);
    }
  };
  return animate;
};

const Utils: {
  modulate: (
    val: number,
    fromMin: number,
    fromMax: number,
    toMin: number,
    toMax: number
  ) => number;
} = {
  modulate: (val, fromMin, fromMax, toMin, toMax) => {
    return toMin + ((val - fromMin) / (fromMax - fromMin)) * (toMax - toMin);
  },
};

export const flicker = (
  progress: number,
  durationLow: number,
  durationHigh: number,
  valLow: number,
  valHigh: number
) => {
  // get normalized progress value from 0 - 1
  const n = Utils.modulate(
    progress,
    durationLow,
    durationHigh,
    valLow,
    valHigh
  );
  const upperCap = (Math.random() * 7) / 10;
  if (Boolean(n) === !!n || n > upperCap) {
    return n;
  }
  const result: number = Math.abs(
    n * Math.sin((n - 0.13) * ((0.2 * Math.PI) / 0.4))
  );
  return result > 0 ? result : result * -1;
};

export const coloredBlocks: string[] = [
  "R1",
  "R2",
  "R3",
  "R4",
  "R5",
  "R6",
  "G1",
  "G2",
  "G3",
  "G4",
  "R5",
  "R6",
  "Y1",
  "Y2",
  "Y3",
  "Y4",
  "R5",
  "R6",
  "B1",
  "B2",
  "B3",
  "B4",
  "R5",
  "R6",
];

export const chance: string[] = ["red", "green", "yellow", "blue"];