#!/usr/bin/env -S deno --allow-read

import fs from "node:fs";

/**
 * Get the guard position in the map.
 * @param {string} input 
 * @returns {number[]}
 */
function getGuardPos(input) {
  const line = input
    .split("")
    .filter((char) =>
      ["^", "\n"].includes(char))
    .join("")
    .indexOf("^")

  const col = input
    .split("\n")[line]
    .indexOf("^");

  return [line, col];
}

/**
 * Givin a guard position, it will drawn an X line where she's poiting to.
 * @param {string[][]} map 
 * @param {number[]} guardPos
 * @returns {{ map: string[][]; guardPos: number[], isOut: boolean }}
 */
function drawnDirectedLine(map, guardPos) {
  const [guardLine, guardCol] = guardPos;
  const direction = map[guardLine][guardCol];

  if (!["^", ">", "v", "<"].includes(direction))
    throw "Invalid guard position";

  const getNextPos =
    direction === "^" ? (li, co) => [li - 1, co] :
      direction === ">" ? (li, co) => [li, co + 1] :
        direction === "v" ? (li, co) => [li + 1, co] :
          direction === "<" ? (li, co) => [li, co - 1] : null;
  const nextDirection =
    direction === "^" ? ">" :
      direction === ">" ? "v" :
        direction === "v" ? "<" :
          direction === "<" ? "^" : null;

  const updatedMap = [...map.map((l) => [...l])];
  let currentPos = guardPos;

  while (true) {
    const [line, col] = currentPos;
    const [nextLine, nextCol] = getNextPos(line, col);

    updatedMap[line][col] = "X";

    try {
      if (updatedMap[nextLine][nextCol] === "#") {
        updatedMap[line][col] = nextDirection;

        return { map: updatedMap, guardPos: [line, col], isOut: false };
      }

      currentPos = [nextLine, nextCol];

    } catch (_) {
      return { map: updatedMap, guardPos: [line, col], isOut: true };
    }
  }
}

/**
 * Iterate over all guard movements and mark the path with X's along the way.
 * @param {string[][]} map 
 * @param {number[]} guardPos 
 * @returns {{ markedMap: string[][]; lastGuardPos: number[]; }}
 */
function markGuardsPath(map, guardPos) {
  let markedMap = [...map.map((l) => [...l])];
  let lastGuardPos = [...guardPos];

  while (true) {
    const data = drawnDirectedLine(markedMap, lastGuardPos);

    markedMap = data.map;
    lastGuardPos = data.guardPos;

    if (data.isOut)
      break;
  }

  return { markedMap, lastGuardPos };
}

/**
 * Drawns the guard's path with X's and just cound them all.
 * @param {string} input 
 * @returns {number}
 */
function solve(input) {
  let map = input.split("\n").map((l) => l.split(""));
  let guardPos = getGuardPos(input);

  const { markedMap } = markGuardsPath(map, guardPos);

  return markedMap
    .map((line) => line.join(""))
    .join("")
    .split("")
    .filter((char) => char === "X")
    .length;
}

const inputPath = process.argv[2];

if (!inputPath) {
  throw "Input file argument required";
}

fs.readFile(inputPath, "utf8", (error, input) => {
  if (error)
    throw error;

  const result = solve(input.trim())

  console.log(result);
});
