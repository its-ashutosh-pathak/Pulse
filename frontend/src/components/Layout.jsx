import React from 'react';
import { Outlet, NavLink } from 'react-router-dom';
import { Home, Library, Search, Settings } from 'lucide-react';
import Player from './Player';
import { useAuth } from '../context/AuthContext';
import './Layout.css';

export default function Layout() {
  const { user } = useAuth();
  const initials = user?.displayName ? user.displayName.split(' ').map(n => n[0]).join('').toUpperCase() : 'P';

  return (
    <div className="app-container">
      <div className="main-content">
        <Outlet />
      </div>

      <Player />

      <nav className="bottom-nav">
        <NavLink to="/" className={({ isActive }) => (isActive ? 'nav-item active' : 'nav-item')}>
          <Home size={22} />
          <span>Home</span>
        </NavLink>
        <NavLink to="/library" className={({ isActive }) => (isActive ? 'nav-item active' : 'nav-item')}>
          <Library size={22} />
          <span>Library</span>
        </NavLink>
        <NavLink to="/search" className={({ isActive }) => (isActive ? 'nav-item active' : 'nav-item')}>
          <Search size={22} />
          <span>Search</span>
        </NavLink>
        <NavLink to="/settings" className={({ isActive }) => (isActive ? 'nav-item active' : 'nav-item')}>
          <Settings size={22} />
          <span>Settings</span>
        </NavLink>
        <NavLink to="/profile" className={({ isActive }) => (isActive ? 'nav-item active nav-profile' : 'nav-item nav-profile')}>
          <div className="nav-avatar-ring">
            {user?.photoURL ? (
              <img src={user.photoURL} alt="" className="nav-avatar" />
            ) : (
              <span className="nav-avatar-initials">{initials}</span>
            )}
          </div>
          <span>Profile</span>
        </NavLink>
      </nav>
    </div>
  );
}
