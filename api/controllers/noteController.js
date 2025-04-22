const db = require("@models");
const Note = db.Note;
const User = db.User;

// 権限に基づくクエリオプションを生成する関数
const getNoteQueryOptions = (userRole, userId) => {
  // 基本的なクエリオプション
  const baseOptions = {
    include: [
      {
        model: User,
        as: "user", // アソシエーションで定義したエイリアスを指定
        attributes: ["id", "name", "email"],
      },
    ],
  };

  // 権限に基づいてwhereを追加
  const rolePermissions = {
    admin: {}, // 管理者は制限なし
    moderator: {}, // モデレーターも全て見える
    user: { where: { userId } }, // 一般ユーザーは自分のノートのみ
  };

  return {
    ...baseOptions,
    ...(rolePermissions[userRole] || rolePermissions.user),
  };
};

exports.getAllNotes = async (req, res, next) => {
  try {
    const { role, id } = req.user;
    console.log("role", role);
    const queryOptions = getNoteQueryOptions(role, id);
    const notes = await Note.findAll(queryOptions);

    res.json(notes);
  } catch (error) {
    console.error("Notes fetching error:", error);
    res.status(500).json({
      message: "ノートの取得に失敗しました",
    });
  }
};

// 管理者用：全ユーザーのノートを取得
exports.getAllNotesForAdmin = async (req, res, next) => {
  try {
    const notes = await Note.find(); // 全部
    res.json(notes);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Admin notes fetching failed." });
  }
};

exports.createNote = async (req, res, next) => {
  try {
    const { title, content, imageUrl } = req.body;
    const note = await Note.create({
      title,
      content,
      imageUrl,
      userId: req.user.id,
    });
    res.status(201).json(note);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Note creation failed." });
  }
};

exports.updateNote = async (req, res, next) => {
  try {
    const { id, title, content, imageUrl } = req.body;
    console.log("NOTE ID:", id);
    console.log("USER ID:", req.user.id);
    const note = await Note.findByPk(id);
    if (!note) {
      return res.status(404).json({ message: "Note not found." });
    }
    if (note.userId !== req.user.id) {
      return res.status(403).json({ message: "Forbidden: Not your note." });
    }
    note.title = title;
    note.content = content;
    note.imageUrl = imageUrl;
    await note.save();
    res.json(note);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Note update failed." });
  }
};

exports.deleteNote = async (req, res) => {
  try {
    const noteId = req.params.id;
    console.log("NOTE ID:", noteId);
    console.log("USER ID:", req.user.id);

    const note = await Note.findByPk(noteId);

    if (!note) {
      return res.status(404).json({ message: "Note not found." });
    }

    if (note.userId !== req.user.id) {
      return res
        .status(403)
        .json({ message: "You are not authorized to delete this note." });
    }

    await note.destroy();
    res.status(200).json({ message: "Note deleted successfully." });
  } catch (error) {
    console.error("Delete error:", error);
    res.status(500).json({ message: "Failed to delete note." });
  }
};
