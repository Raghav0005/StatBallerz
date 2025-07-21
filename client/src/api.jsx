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
  const formatPlayerName = (name) => {
    return name
      .trim()
      .toLowerCase()
      .split(" ")
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  };

  const formattedName = formatPlayerName(pname);
  const res = await fetch(`/api/player/search?pname=${encodeURIComponent(formattedName)}`);

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

export async function searchTeam(teamName) {
  const formatTeamName = (name) => {
    return name
      .trim()
      .toLowerCase()
      .split(" ")
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  };
  const formattedName = formatTeamName(teamName);
  const res = await fetch(`/api/team/search?teamname=${encodeURIComponent(formattedName)}`);
  if (res.ok) {
    const data = await res.json();
    console.log("searchTeam success:", data);
    return data;
  } else if (res.status === 400) {
    console.log("searchTeam unauthorized");
    return { error: "Search string" };
  } else {
    console.error("searchTeam failed:", res.status);
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

export async function fetchGameDetails(gameIds) {
  const res = await fetch(`/api/games/teams?gameIds=${encodeURIComponent(gameIds)}`);

  if (res.ok) {
    const data = await res.json();
    console.log("fetchGameDetails success:", data);
    return { data };
  } else {
    console.error("fetchGameDetails failed:", res.status);
    throw new Error("Fetch game details failed");
  }
}

export async function getAnsweredAllQuestionsAsUser(username) {
  const res = await fetch(`/api/special-queries/answered-all-questions?username=${encodeURIComponent(username)}`);

  if (res.ok) {
    const data = await res.json();
    console.log("getAnsweredAllQuestionsAsUser success:", data);
    return data;
  } else if (res.status === 400) {
    console.log("getAnsweredAllQuestionsAsUser bad request");
    return { error: "Username required" };
  } else {
    console.error("getAnsweredAllQuestionsAsUser failed:", res.status);
    throw new Error("Special query failed");
  }
}

export async function getAnsweredAllCorrectSingleAttempt() {
  const res = await fetch("/api/special-queries/answered-all-correct-single-attempt");

  if (res.ok) {
    const data = await res.json();
    console.log("getAnsweredAllCorrectSingleAttempt success:", data);
    return data;
  } else if (res.status === 500) {
    console.log("getAnsweredAllCorrectSingleAttempt server error");
    return { error: "Failed to retrieve results" };
  } else {
    console.error("getAnsweredAllCorrectSingleAttempt failed:", res.status);
    throw new Error("Special query failed");
  }
}

export async function insertQuestion(username, questionText, answers) {
  const requestData = {
    username: username,
    questionText: questionText,
    answers: answers // Array of {text: string, isCorrect: string}
  };

  const res = await fetch("/api/question", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestData),
  });

  if (res.ok) {
    const data = await res.json();
    console.log("addQuestion success:", data);
    return { data };
  } else if (res.status === 400) {
    const errorData = await res.json();
    console.log("addQuestion bad request:", errorData.error);
    return { error: errorData.error };
  } else if (res.status === 404) {
    console.log("addQuestion user not found");
    return { error: "User not found." };
  } else {
    console.error("addQuestion failed:", res.status);
    throw new Error("Add question failed");
  }
}

export async function fetchRandomQuiz() {
  const res = await fetch("/api/quiz/random", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  });

  if (res.ok) {
    const data = await res.json();
    console.log("fetchRandomQuiz success:", data);
    return { data };
  } else if (res.status === 404) {
    console.log("fetchRandomQuiz no questions available");
    return { error: "No questions available in the database." };
  } else {
    console.error("fetchRandomQuiz failed:", res.status);
    const errorData = await res.json().catch(() => ({}));
    return { error: errorData.error || "Failed to fetch quiz questions." };
  }
}

export async function submitQuizAttempt(username, questions, userAnswers) {
  let score = 0;
  const attemptItems = [];
  
  questions.forEach((question, index) => {
    const userAnswer = userAnswers[index];
    const isCorrect = question.answer === userAnswer;
    
    if (isCorrect) {
      score++;
    }
    
    const answerNumber = question.options.findIndex(option => option === userAnswer) + 1;
    
    if (answerNumber > 0) {
      attemptItems.push({
        questionId: question.questionId,
        answerNumber: answerNumber
      });
    }
  });

  const requestData = {
    username: username,
    score: score,
    attemptItems: attemptItems
  };

  const res = await fetch("/api/quiz/submit", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestData),
  });

  if (res.ok) {
    const data = await res.json();
    console.log("submitQuizAttempt success:", data);
    return { data };
  } else if (res.status === 400) {
    const errorData = await res.json();
    console.log("submitQuizAttempt bad request:", errorData.error);
    return { error: errorData.error };
  } else if (res.status === 404) {
    console.log("submitQuizAttempt user not found");
    return { error: "User not found." };
  } else {
    console.error("submitQuizAttempt failed:", res.status);
    const errorData = await res.json().catch(() => ({}));
    return { error: errorData.error || "Failed to submit quiz attempt." };
  }
}

export async function fetchQuestionCount() {
  const res = await fetch("/api/questions/count", {
    method: "GET",
  });

  if (res.ok) {
    const data = await res.json();
    console.log("fetchQuestionCount success:", data);
    return { data };
  } else {
    console.error("fetchQuestionCount failed:", res.status);
    throw new Error("Fetch question count failed");
  }
}