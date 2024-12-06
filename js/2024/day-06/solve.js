#!/usr/bin/env -S deno --allow-read

import fs from "node:fs";

/**
 * Get the guard position in the map.
 * @param {string} input 
 * @returns {{ line: number; col: number; }}
 */
function getGuardPos(input) {
  const row = input
    .split("")
    .filter((char) =>
      ["^", "\n"].includes(char))
    .join("")
    .indexOf("^")

  const col = input
    .split("\n")[row]
    .indexOf("^");

  return { row, col };
}

/**
 * Returns the path positions of the guard or null if a loop was found.
 * @param {string[][]} grid 
 * @param {{ row: number; col: number; }} current 
 * @param {string} direction 
 * @returns {{ row: number; col: number; }[]}
 */
function getGuardPath(grid, current, direction) {
  let acc = [];

  while (true) {
    const directions = {
      "^": { next: { row: current.row - 1, col: current.col }, turn: ">" },
      ">": { next: { row: current.row, col: current.col + 1 }, turn: "v" },
      "v": { next: { row: current.row + 1, col: current.col }, turn: "<" },
      "<": { next: { row: current.row, col: current.col - 1 }, turn: "^" },
    }

    if (acc.length >= 6) {
      const [tail, head] = [acc.slice(2, -2), acc.slice(-2)];

      if (tail.some((curr, idx, arr) => {
        if (idx === 0)
          return false;

        const prev = arr[idx - 1];

        return (
          head[0].row === prev.row && head[0].col === prev.col &&
          head[1].row === curr.row && head[1].col === curr.col
        )
      }))
        return null;
    }

    const { next: { row, col }, turn } = directions[direction];

    if (row < 0 || row >= grid.length || col < 0 || col >= grid[0].length) {
      acc.push(current);
      break;
    }

    const target = grid[row][col];

    if (!"^>v<.X".includes(target)) {
      direction = turn;

      continue;
    }

    acc.push(current);

    current = { row, col };
  }

  return acc;
}

/**
 * For each position in the guards path, put an obstacle and count if it loops.
 * @param {string} input 
 * @returns {number}
 */
function solve(input) {
  const guard = getGuardPos(input);
  const grid = input.split("\n").map((line) => line.split(""));

  // This massive line get all unique positions in the guard's path.
  const [_, ...path] = getGuardPath(grid, guard, "^")
    .map(({ row, col }) => `${row},${col}`)
    .filter((pos, key, arr) => arr.indexOf(pos) === key)
    .map((pos) => pos.split(",").map(Number))
    .map(([row, col]) => ({ row, col }))

  let count = 0;

  path.forEach(({ row, col }) => {
    const temp = grid[row][col];

    grid[row][col] = "O";  // Put an obstacle

    if (getGuardPath(grid, guard, "^") === null)
      count++;

    grid[row][col] = temp;  // Removes the obstacle
  })

  return count;
}

const inputPath = process.argv[2];

if (!inputPath) {
  throw new Error("Input file argument required");
}

fs.readFile(inputPath, "utf8", (error, input) => {
  if (error)
    throw error;

  const result = solve(input.trim())

  console.log(result);
});
