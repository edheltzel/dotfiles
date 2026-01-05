import { ref, onMounted, onUnmounted } from 'vue';
import type { HookEvent, WebSocketMessage } from '../types';

export type ConnectionState = 'connected' | 'reconnecting' | 'shutdown';

export function useWebSocket(url: string) {
  const events = ref<HookEvent[]>([]);
  const isConnected = ref(false);
  const error = ref<string | null>(null);
  const connectionState = ref<ConnectionState>('connected');

  let ws: WebSocket | null = null;
  let reconnectTimeout: number | null = null;
  let reconnectAttempts = 0;
  const MAX_RECONNECT_ATTEMPTS = 3;

  // Get max events from environment variable or use default
  const maxEvents = parseInt(import.meta.env.VITE_MAX_EVENTS_TO_DISPLAY || '100');
  
  const connect = () => {
    try {
      ws = new WebSocket(url);
      
      ws.onopen = () => {
        console.log('WebSocket connected');
        isConnected.value = true;
        connectionState.value = 'connected';
        error.value = null;
        reconnectAttempts = 0; // Reset on successful connection
      };
      
      ws.onmessage = (event) => {
        try {
          const message: WebSocketMessage = JSON.parse(event.data);
          
          if (message.type === 'initial') {
            const initialEvents = Array.isArray(message.data) ? message.data : [];
            // Only keep the most recent events up to maxEvents
            events.value = initialEvents.slice(-maxEvents);
          } else if (message.type === 'event') {
            const newEvent = message.data as HookEvent;
            events.value.push(newEvent);
            
            // Limit events array to maxEvents, removing the oldest when exceeded
            if (events.value.length > maxEvents) {
              // Remove the oldest events (first 10) when limit is exceeded
              events.value = events.value.slice(events.value.length - maxEvents + 10);
            }
          }
        } catch (err) {
          console.error('Failed to parse WebSocket message:', err);
        }
      };
      
      ws.onerror = (err) => {
        console.error('WebSocket error:', err);
        error.value = 'WebSocket connection error';
      };
      
      ws.onclose = () => {
        console.log('WebSocket disconnected');
        isConnected.value = false;

        // Increment reconnect attempts
        reconnectAttempts++;

        // If we've exceeded max attempts, assume permanent shutdown
        if (reconnectAttempts >= MAX_RECONNECT_ATTEMPTS) {
          console.log('Max reconnect attempts reached. Server appears to be shutdown.');
          connectionState.value = 'shutdown';
          error.value = null; // Clear error on graceful shutdown
          return;
        }

        // Otherwise, mark as reconnecting and try again
        connectionState.value = 'reconnecting';
        error.value = `Reconnecting... (attempt ${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS})`;

        reconnectTimeout = window.setTimeout(() => {
          console.log(`Reconnection attempt ${reconnectAttempts}/${MAX_RECONNECT_ATTEMPTS}...`);
          connect();
        }, 3000);
      };
    } catch (err) {
      console.error('Failed to connect:', err);
      error.value = 'Failed to connect to server';
    }
  };
  
  const disconnect = () => {
    if (reconnectTimeout) {
      clearTimeout(reconnectTimeout);
      reconnectTimeout = null;
    }
    
    if (ws) {
      ws.close();
      ws = null;
    }
  };
  
  onMounted(() => {
    connect();
  });
  
  onUnmounted(() => {
    disconnect();
  });

  const clearEvents = () => {
    events.value = [];
  };

  return {
    events,
    isConnected,
    error,
    connectionState,
    clearEvents
  };
}