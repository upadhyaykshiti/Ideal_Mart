import axios from 'axios';

const API_BASE = 'http://localhost:8000';

export const fetchUsers = async () => {
  const res = await axios.get(`${API_BASE}/users`);
  return res.data;
};

export const fetchUserItems = async (userId) => {
  const res = await axios.get(`${API_BASE}/shopping-items/${userId}`);
  return res.data;
};
