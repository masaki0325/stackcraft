import { useState, useEffect } from "react";

const NoteList = () => {
  const [notes, setNotes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchNotes = async () => {
      try {
        const response = await fetch(`${process.env.REACT_APP_API}/notes`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });

        if (!response.ok) {
          throw new Error("ノート一覧の取得に失敗しました");
        }

        const data = await response.json();
        setNotes(data);
      } catch (error) {
        setError(error.message);
      } finally {
        setLoading(false);
      }
    };

    fetchNotes();
  }, []);

  if (loading) return <div className="p-4">読み込み中...</div>;
  if (error) return <div className="p-4 text-red-600">{error}</div>;

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold mb-6">ノート一覧</h1>
      <div className="bg-white shadow-md rounded-lg overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                タイトル
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                作成者
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                作成日
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {notes.map((note) => (
              <tr key={note.id} className="hover:bg-gray-50">
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {note.title}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {note.user?.name}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {new Date(note.createdAt).toLocaleDateString("ja-JP")}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default NoteList;
