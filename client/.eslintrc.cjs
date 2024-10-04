// module.exports = {
//     env: { browser: true, es2020: true },
//     extends: [
//         "eslint:recommended",
//         "plugin:@typescript-eslint/recommended",
//         "plugin:react-hooks/recommended",
//     ],
//     parser: "@typescript-eslint/parser",
//     parserOptions: { ecmaVersion: "latest", sourceType: "module" },
//     plugins: ["react-refresh"],
//     rules: {
//         "react-refresh/only-export-components": "warn",
//         "@typescript-eslint/no-inferrable-types": "off",
//         "no-mixed-spaces-and-tabs": 0, 
//         'prefer-const': 'warn',
//         '@typescript-eslint/no-empty-function': 'off',
//         "@typescript-eslint/ban-types": "off",
//         "@typescript-eslint/no-unused-vars": "warn",
//         "@typescript-eslint/no-explicit-any": "warn"
//     },
// };

module.exports = {
  env: { browser: true, es2020: true },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react-hooks/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: { ecmaVersion: "latest", sourceType: "module" },
  plugins: ["react-refresh"],
  rules: {
    "react-refresh/only-export-components": "warn",
  },
  ignorePatterns: ["src/dojo/typescript/models.gen.ts"],
};
