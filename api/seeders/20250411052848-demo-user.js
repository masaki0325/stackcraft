"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // await queryInterface.bulkInsert("Users", [
    //   {
    //     name: "John Doe",
    //     email: "john@example.com",
    //     password: "password",
    //     createdAt: new Date(),
    //     updatedAt: new Date(),
    //   },
    //   {
    //     name: "Jane Doe",
    //     email: "jane@example.com",
    //     password: "password",
    //     createdAt: new Date(),
    //     updatedAt: new Date(),
    //   },
    // ]);
  },

  async down(queryInterface, Sequelize) {
    // await queryInterface.bulkDelete("Users", null, {});
  },
};
