export async function signup(username, password) {
  const formData = new FormData();
  formData.append("username", username);
  formData.append("password", password);

  const res = await fetch("/api/signup", {
    method: "POST",
    body: formData,
  });

  const data = await res.json();
  return data;
}

export async function signin(username, password) {
  const res = await fetch(`/api/signin?username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}`);

  const data = await res.json();
  return data;
}