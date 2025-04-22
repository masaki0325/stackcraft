"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // await queryInterface.bulkInsert("Notes", [
    //   {
    //     title: "最初のメモ",
    //     content: "これはテスト用のノートです。",
    //     imageUrl: "https://example.com/image.png",
    //     userId: 1,
    //     createdAt: new Date(),
    //     updatedAt: new Date(),
    //   },
    //   {
    //     title: "2つ目のメモ",
    //     content: "ユーザー1による2番目のノート。",
    //     imageUrl: null,
    //     userId: 1,
    //     createdAt: new Date(),
    //     updatedAt: new Date(),
    //   },
    // ]);
  },

  async down(queryInterface, Sequelize) {
    // await queryInterface.bulkDelete("Notes", null, {});
  },
};
