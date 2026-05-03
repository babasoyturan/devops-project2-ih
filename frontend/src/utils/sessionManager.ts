export const getSessionId = (): string => {
  let sessionId = localStorage.getItem('sessionId');
  
  if (!sessionId) {
    sessionId = `session_${Date.now()}_${Math.random().toString(36).slice(2, 11)}`;
    localStorage.setItem('sessionId', sessionId);
  }
  
  return sessionId;
};

export const clearSession = (): void => {
  localStorage.removeItem('sessionId');
};
