import React, { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';

function UserDetail() {
  const { id } = useParams(); // ✅ Use correct param
  const [items, setItems] = useState([]);

  useEffect(() => {
    fetch(`http://localhost:8000/shopping-items/${id}`)
      .then(res => res.json())
      .then(data => {
        console.log("Fetched items:", data);
        setItems(data);
      });
  }, [id]);

  return (
    <div style={{ padding: '2rem' }}>
      <Link to="/">← Back</Link>
      <h2>Shopping List</h2>
      <ul>
        {items.map(item => (
          <li key={item._id}>
            {item.title} - {item.repeat_interval} at {item.reminder_time}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default UserDetail;
