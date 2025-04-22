"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("Users", "role", {
      type: Sequelize.ENUM("user", "admin", "moderator"),
      defaultValue: "user",
      allowNull: false,
      after: "password", // passwordカラムの後に追加
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("Users", "role");
    await queryInterface.sequelize.query(
      "DROP TYPE IF EXISTS enum_Users_role;"
    );
  },
};
