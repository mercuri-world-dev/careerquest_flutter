from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np

try:
    from sentence_transformers import SentenceTransformer
    HAS_SBERT = True
except Exception:
    HAS_SBERT = False


class SkillVectorizer:
    """Simple vectorizer wrapper. Supports 'tfidf' and optional 'sbert'.

    - TF-IDF: lightweight, fast, interpretable features (unigrams/bigrams)
    - SBERT: semantic dense embeddings (requires sentence-transformers)
    """

    def __init__(self, method='tfidf', sbert_model='all-MiniLM-L6-v2', max_features=2000):
        self.method = method
        self.max_features = max_features
        self.sbert_model = sbert_model
        if method == 'tfidf':
            self.vectorizer = TfidfVectorizer(max_features=max_features, ngram_range=(1, 2), stop_words='english')
            self.model = None
        elif method == 'sbert':
            if not HAS_SBERT:
                raise RuntimeError('sentence-transformers not installed. Install optional dependency to use sbert.')
            self.model = SentenceTransformer(sbert_model)
            self.vectorizer = None
        else:
            raise ValueError('Unknown method: %s' % method)

    def fit(self, texts):
        if self.method == 'tfidf':
            self.vectorizer.fit(texts)

    def fit_transform(self, texts):
        if self.method == 'tfidf':
            X = self.vectorizer.fit_transform(texts)
            return X.toarray()
        else:
            embeddings = self.model.encode(texts, convert_to_numpy=True, show_progress_bar=False)
            return embeddings

    def transform(self, text):
        if self.method == 'tfidf':
            try:
                vec = self.vectorizer.transform([text]).toarray()[0]
            except Exception:
                vec = self.vectorizer.fit_transform([text]).toarray()[0]
            return vec
        else:
            return self.model.encode([text], convert_to_numpy=True)[0]

    def extract_keywords(self, text, top_n=10):
        vf = TfidfVectorizer(max_features=self.max_features, ngram_range=(1, 2), stop_words='english')
        X = vf.fit_transform([text])
        feature_names = np.array(vf.get_feature_names_out())
        scores = X.toarray().flatten()
        if scores.sum() == 0:
            return []
        top_idx = np.argsort(scores)[::-1][:top_n]
        return feature_names[top_idx].tolist()
