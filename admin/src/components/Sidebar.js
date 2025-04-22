import { Link, useLocation } from "react-router-dom";

export default function Sidebar({ onLogout }) {
  const location = useLocation();

  const menuItems = [
    { path: "/users", label: "ユーザー一覧", icon: "users" },
    { path: "/notes", label: "ノート一覧", icon: "document-text" },
  ];

  return (
    <div className="bg-gray-800 text-white w-64 min-h-screen p-4">
      <div className="text-xl font-bold mb-8">管理画面</div>
      <nav>
        {menuItems.map((item) => (
          <Link
            key={item.path}
            to={item.path}
            className={`flex items-center space-x-2 p-3 rounded-lg mb-2 ${
              location.pathname === item.path
                ? "bg-gray-700 text-white"
                : "text-gray-300 hover:bg-gray-700 hover:text-white"
            }`}
          >
            <span>{item.label}</span>
          </Link>
        ))}
      </nav>
      <div className="mt-auto px-4 py-4 border-t border-gray-700">
        <button
          onClick={onLogout}
          className="w-full px-4 py-2 text-sm text-white bg-red-600 rounded hover:bg-red-700"
        >
          ログアウト
        </button>
      </div>
    </div>
  );
}
