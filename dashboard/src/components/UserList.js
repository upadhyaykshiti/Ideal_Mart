

import React, { useEffect, useState } from 'react';
import { fetchUsers } from '../services/api';
import { Link } from 'react-router-dom';

export default function UserList() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetchUsers().then(setUsers).catch(console.error);
  }, []);

  return (
    <div>
      <h2>Registered Users</h2>
      <ul>
        {users.map((user) => (
          <li key={user._id}>
            <Link to={`/user/${user._id}`}>{user.name} ({user.email})</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}