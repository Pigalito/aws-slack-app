jest.spyOn(console, 'log');

const lambda = require('../');

it("logs event", async () => {
  const event = {
    key: 'value'
  };

  await lambda.handler(event);

  expect(console.log).toBeCalledWith(event);
});