// jest.config.js - Kompakte JavaScript/TypeScript Test-Konfiguration
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/__tests__/**/*.(js|jsx|ts|tsx)', '**/*.(test|spec).(js|jsx|ts|tsx)'],
  moduleFileExtensions: ['js', 'jsx', 'ts', 'tsx', 'json'],
  
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': 'babel-jest'
  },
  
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  
  collectCoverage: true,
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!**/node_modules/**'
  ],
  
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'html', 'lcov'],
  
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  
  testTimeout: 30000,
  verbose: true,
  clearMocks: true,
  
  reporters: [
    'default',
    ['jest-junit', { outputDirectory: 'test-results', outputName: 'junit.xml' }]
  ]
};
