import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import { useState, useEffect } from "react";
import Login from "./components/Login";
import UserList from "./components/UserList";
import NoteList from "./components/NoteList";
import Sidebar from "./components/Sidebar";
import "./App.css";

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // ローカルストレージからユーザー情報を復元
    const token = localStorage.getItem("token");
    const savedUser = localStorage.getItem("user");

    if (token && savedUser) {
      setUser(JSON.parse(savedUser));
    }
    setLoading(false);
  }, []);

  // Login コンポーネントで使用するログインハンドラー
  const handleLogin = (userData) => {
    setUser(userData);
    localStorage.setItem("user", JSON.stringify(userData));
  };

  // ログアウトハンドラー
  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    setUser(null);
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  if (!user) {
    return <Login onLogin={handleLogin} />;
  }

  return (
    <Router>
      <div className="flex min-h-screen">
        <Sidebar onLogout={handleLogout} />
        <div className="flex-1 bg-gray-100">
          <header className="bg-white shadow">
            <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
              <h1 className="text-3xl font-bold text-gray-900">
                <Routes>
                  <Route path="/users" element={<>ユーザー管理</>} />
                  <Route path="/notes" element={<>ノート管理</>} />
                </Routes>
              </h1>
            </div>
          </header>
          <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
            <Routes>
              <Route path="/users" element={<UserList />} />
              <Route path="/notes" element={<NoteList />} />
              <Route path="/" element={<Navigate to="/users" replace />} />
            </Routes>
          </main>
        </div>
      </div>
    </Router>
  );
}

export default App;
