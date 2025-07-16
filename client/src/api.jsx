export async function signupUser(username, password) {
  const formData = new FormData();
  formData.append("username", username);
  formData.append("password", password);

  const res = await fetch("/api/signup", {
    method: "POST",
    body: formData,
  });

  if (res.ok) {
    const data = await res.json();
    console.log("signupUser success:", data);
    return { data };
  } else if (res.status === 409) {
    console.log("signupUser conflict");
    return { error: "Username already exists." };
  } else {
    console.error("signupUser failed:", res.status);
    throw new Error("Signup failed");
  }
}

export async function signinUser(username, password) {
  const res = await fetch(
    `/api/signin?username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}`
  );

  if (res.ok) {
    const data = await res.json();
    console.log("signinUser success:", data);
    return { data };
  } else if (res.status === 401) {
    console.log("signinUser unauthorized");
    return { error: "Invalid username or password." };
  } else {
    console.error("signinUser failed:", res.status);
    throw new Error("Signin failed");
  }
}

export async function deleteUser(username) {
  const res = await fetch(`/api/user?username=${encodeURIComponent(username)}`, {
    method: "DELETE",
  });

  if (res.ok) {
    const data = await res.json();
    console.log("deleteUser success:", data);
    return { data };
  } else {
    console.error("deleteUser failed:", res.status);
    throw new Error("Delete user failed");
  }
}

export async function updatePassword(username, password) {
  const res = await fetch(
    `/api/password?username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}`,
    {
      method: "POST",
    }
  );

  if (res.ok) {
    const data = await res.json();
    console.log("updatePassword success:", data);
    return { data };
  } else {
    console.error("updatePassword failed:", res.status);
    throw new Error("Update password failed");
  }
}

export async function searchPlayer(pname) {
  const res = await fetch(`/api/search?pname=${encodeURIComponent(pname)}`);

  if (res.ok) {
    const data = await res.json();
    console.log("searchPlayer success:", data);
    return data;
  } else if (res.status === 400) {
    console.log("searchPlayer unauthorized");
    return { error: "Search string" };
  } else {
    console.error("searchPlayer failed:", res.status);
    throw new Error("Search failed");
  }
}

// games
export async function fetchGameStats(startDate, endDate, stat) {
  const res = await fetch(
    `/api/games/stats?startDate=${encodeURIComponent(startDate)}&endDate=${encodeURIComponent(
      endDate
    )}&stat=${encodeURIComponent(stat)}`
  );

  if (res.ok) {
    const data = await res.json();
    console.log("fetchGameStats success:", data);
    return { data };
  } else {
    console.error("fetchGameStats failed:", res.status);
    throw new Error("Fetch game stats failed");
  }
}

export async function getAnsweredAllQuestionsAsUser(username) {
  const res = await fetch(`/api/special-queries/answered-all-questions?username=${encodeURIComponent(username)}`);
  
  if (res.ok) {
    const data = await res.json();
    console.log('getAnsweredAllQuestionsAsUser success:', data);
    return data;
  } else if (res.status === 400) {
    console.log('getAnsweredAllQuestionsAsUser bad request');
    return { error: "Username required" };
  } else {
    console.error('getAnsweredAllQuestionsAsUser failed:', res.status);
    throw new Error("Special query failed");
  }
}
