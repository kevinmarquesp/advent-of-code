#!/usr/bin/env -S deno --allow-read

import fs from "node:fs";

/**
 * Parses the puzzle input to objects that Javascript can understand better.
 * @param {string} input 
 * @returns {{ rules: number[][]; updates: number[][]; }}
 */
function parse(input) {
  const [rawRules, rawUpdates] = input.split("\n\n");

  const rules = rawRules.split("\n").map((rawRule) =>
    rawRule.split("|").map(Number));
  const updates = rawUpdates.split("\n").map((rawUpdate) =>
    rawUpdate.split(",").map(Number));

  return { rules, updates };
}

/**
 * Creates a dictionary with numbers that should be found after the others.
 * @param {number[][]} rules
 * @returns {{[id: string]: number[]}}
 */
function getRulesReferenceDictionary(rules) {
  const dict = {};

  rules.forEach(([before, after]) => {
    if (!(before in dict)) {
      dict[before] = [after];

      return;
    }

    dict[before].push(after);
  });

  return dict;
}

/**
 * Returns the invlid elements of an specified page by a reference dictionary.
 * @param {{[id: string]: number[]}} reference
 * @param {number[]} update 
 * @returns {number[]}
 */
function getInvalidUpdatePages(reference, update) {
  const before = [];

  return update.filter((page) => {
    before.push(page);

    // Just ignore if the page is not referenced.
    if (!(page in reference))
      return false;

    // Use only the after pages that actually exists in the current page.
    const after = reference[page].filter((p) => update.includes(p));

    // What is meant to be after, should not appear in the before list.
    return after.filter((p) => before.includes(p)).length > 0;
  });
}

/**
 * Filter for the valid ones, map to get the middle from each them sum it all.
 * @param {string} input 
 * @returns {number}
 */
function solve(input) {
  const { rules, updates } = parse(input);
  const reference = getRulesReferenceDictionary(rules);

  return updates
    .filter((update) =>
      getInvalidUpdatePages(reference, update).length == 0) // No invalid
    .map((update) =>
      update[Math.floor(update.length / 2)]) // Get middle page number
    .reduce((acc, page) => acc + page); // Sum everything
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
