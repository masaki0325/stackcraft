"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Note extends Model {
    static associate(models) {
      // define association here
      // Note は User に属している（外部キー: userId）
      Note.belongsTo(models.User, {
        foreignKey: "userId",
        as: "user",
        onDelete: "CASCADE",
      });
    }
  }
  Note.init(
    {
      title: DataTypes.STRING,
      content: DataTypes.TEXT,
      imageUrl: DataTypes.STRING,
      userId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Note",
    }
  );
  return Note;
};
