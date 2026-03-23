import { Link } from 'expo-router';
import { Pressable, StyleSheet } from 'react-native';

import EditScreenInfo from '@/components/EditScreenInfo';
import { Text, View } from '@/components/Themed';

export default function TabOneScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Tab One</Text>
      <View style={styles.separator} lightColor="#eee" darkColor="rgba(255,255,255,0.1)" />
      {__DEV__ ? (
        <Link href="/dev/supabase-health" asChild>
          <Pressable style={styles.devLink}>
            <Text style={styles.devLinkText}>Dev: Supabase health / RLS</Text>
          </Pressable>
        </Link>
      ) : null}
      <EditScreenInfo path="app/(tabs)/index.tsx" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  separator: {
    marginVertical: 30,
    height: 1,
    width: '80%',
  },
  devLink: {
    marginBottom: 16,
    paddingVertical: 10,
    paddingHorizontal: 14,
    backgroundColor: '#1d4ed8',
    borderRadius: 8,
  },
  devLinkText: {
    color: '#fff',
    fontWeight: '600',
    fontSize: 14,
  },
});
