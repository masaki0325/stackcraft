"use strict";
const bcrypt = require("bcryptjs");

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const adminPassword = await bcrypt.hash("password", 10);
    const moderatorPassword = await bcrypt.hash("password", 10);

    await queryInterface.bulkInsert("Users", [
      {
        name: "管理者",
        email: "admin@admin.com",
        password: adminPassword,
        role: "admin",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        name: "モデレーター",
        email: "moderator@moderator.com",
        password: moderatorPassword,
        role: "moderator",
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("Users", {
      email: {
        [Sequelize.Op.in]: ["admin@admin.com", "moderator@moderator.com"],
      },
    });
  },
};
